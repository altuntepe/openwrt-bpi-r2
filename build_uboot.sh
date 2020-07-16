#!/usr/bin/env bash

. build_env.sh start

# go to the u-boot directory
pushd $UBOOT_DIR
echo "Building u-boot..."

# add a custom uEnv.txt
cp $CONFIG_DIR/uEnv.txt $UBOOT_DIR/

# apply patches
for patch_file in $PATCH_DIR/u-boot/*.patch; do
    [ -f "$patch_file" ] || break

    echo "Applying patch $patch_file"

    # check if it's a git patch or not
    if grep -q -- "--git" "$patch_file"; then
        # ignore a or b path prefix in the patch file
        patch -d $UBOOT_DIR -p1 < "$patch_file"
    else
        patch -d $UBOOT_DIR < "$patch_file"
    fi
done

# build u-boot
./build.sh importconfig
./build.sh build
popd


. build_env.sh stop
