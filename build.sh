
echo "Clearing past builds..."
rimraf build

PKG_VERSION=`node -p "require('./package.json').version"`
PKG_NAME=`node -p "require('./package.json').name"`

echo "Building app"
BUNDLE_NAME="$PKG_NAME-$PKG_VERSION.zip"
bestzip "$BUNDLE_NAME" docker-compose.yml proxy .env.example nginx.conf README.md list-service.sh restart-service.sh stop-service.sh startup-service.sh update-service.sh view-logs.sh
mkdir "build"
mv $BUNDLE_NAME build

