#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="TimeMachineTrimmer"
BUILD_DIR="$PROJECT_DIR/build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
DMG_RW="$BUILD_DIR/${APP_NAME}_rw.dmg"
DMG_PATH="$BUILD_DIR/$APP_NAME.dmg"
STAGING_DIR="/tmp/${APP_NAME}_dmg_staging"
BG_SVG="$PROJECT_DIR/.scripts/DMGBackground.svg"
BG_PNG="/tmp/${APP_NAME}_bg.png"
VOLUME_NAME="$APP_NAME"
MOUNT_POINT="/Volumes/$VOLUME_NAME"

echo "==> Building app..."
"$PROJECT_DIR/.scripts/build_debug.sh"

echo "==> Rendering DMG background..."
rm -f "$BG_PNG"
if [ -f "$BG_SVG" ]; then
    rsvg-convert --width=400 --height=300 "$BG_SVG" -o "$BG_PNG"
    echo "    background: $BG_PNG"
else
    echo "    warning: background SVG not found"
fi

echo "==> Preparing DMG staging..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

cp -R "$APP_BUNDLE" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

echo "==> Creating read-write DMG..."
rm -f "$DMG_RW"

hdiutil create \
  -volname "$VOLUME_NAME" \
  -srcfolder "$STAGING_DIR" \
  -fs HFS+ \
  -format UDRW \
  -size 200m \
  -ov \
  "$DMG_RW"

rm -rf "$STAGING_DIR"

echo "==> Mounting DMG to configure appearance..."
if [ -d "$MOUNT_POINT" ]; then
    hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
fi

hdiutil attach "$DMG_RW" -noverify -mountpoint "$MOUNT_POINT"

# Set background image
if [ -f "$BG_PNG" ]; then
    mkdir -p "$MOUNT_POINT/.background"
    cp "$BG_PNG" "$MOUNT_POINT/.background/background.png"
fi

# Configure Finder window layout (before setting volume icon, since Finder may rewrite .VolumeIcon.icns)
echo "==> Configuring Finder window..."
sleep 1
open "$MOUNT_POINT"
sleep 2

osascript <<ASCEOF
tell application "Finder"
    set f to POSIX file "$MOUNT_POINT" as alias
    set theWin to container window of f
    set current view of theWin to icon view
    set toolbar visible of theWin to false
    set statusbar visible of theWin to false
    set the bounds of theWin to {100, 100, 500, 400}
    set opts to icon view options of theWin
    set arrangement of opts to not arranged
    set icon size of opts to 80
    set text size of opts to 12
    try
        set background picture of opts to POSIX file "$MOUNT_POINT/.background/background.png"
    on error errMsg
        log "bg posix err: " & errMsg
    end try
    try
        set background picture of opts to file "$VOLUME_NAME:.background:background.png"
    on error errMsg
        log "bg hfs err: " & errMsg
    end try
    try
        set position of item "$APP_NAME.app" of f to {120, 195}
    end try
    try
        set position of item "Applications" of f to {280, 195}
    end try
    update f
end tell
ASCEOF

# Set volume icon AFTER Finder config (Finder may remove .VolumeIcon.icns when writing .DS_Store)
ICNS_SRC="$APP_BUNDLE/Contents/Resources/AppIcon.icns"
if [ -f "$ICNS_SRC" ]; then
    cp "$ICNS_SRC" "$MOUNT_POINT/.VolumeIcon.icns"
    echo "    volume icon: copied $(wc -c < "$MOUNT_POINT/.VolumeIcon.icns") bytes"
    SetFile -a C "$MOUNT_POINT"
    echo "    volume icon: custom icon bit set"
else
    echo "    warning: app icon not found at $ICNS_SRC"
fi

echo "==> Unmounting..."
sleep 2
hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true

echo "==> Converting to compressed DMG..."
rm -f "$DMG_PATH"
hdiutil convert "$DMG_RW" -format UDZO -imagekey zlib-level=9 -o "$DMG_PATH"
rm -f "$DMG_RW" "$BG_PNG"

echo ""
echo "✅ DMG created: $DMG_PATH"
echo ""
echo "To open: open \"$DMG_PATH\""
