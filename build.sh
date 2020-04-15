#!/bin/bash

set -e

## Build TwitterKit.framework - x86_64
xcodebuild \
    -project TwitterKit/TwitterKit.xcodeproj \
    -scheme TwitterKit -configuration Debug \
    -sdk "iphonesimulator" \
    HEADER_SEARCH_PATHS="$(pwd)/TwitterCore/iphonesimulator/Headers $(pwd)/TwitterCore/iphonesimulator/PrivateHeaders"  \
    CONFIGURATION_BUILD_DIR=./iphonesimulator \
    clean build

## Build TwitterKit.framework - armv7, arm64
xcodebuild \
    -project TwitterKit/TwitterKit.xcodeproj \
    -scheme TwitterKit -configuration Debug \
    -sdk "iphoneos" \
    HEADER_SEARCH_PATHS="$(pwd)/TwitterCore/iphoneos/Headers $(pwd)/TwitterCore/iphoneos/PrivateHeaders"  \
    CONFIGURATION_BUILD_DIR=./iphoneos \
    clean build

## Merge into one TwitterKit.framework with x86_64, armv7, arm64
rm -rf iOS
mkdir -p iOS
cp -r TwitterKit/iphoneos/TwitterKit.framework/ iOS/TwitterKit.framework
lipo -create -output iOS/TwitterKit.framework/TwitterKit TwitterKit/iphoneos/TwitterKit.framework/TwitterKit TwitterKit/iphonesimulator/TwitterKit.framework/TwitterKit
lipo -archs iOS/TwitterKit.framework/TwitterKit

## Zip them into TwitterKit.zip
rm TwitterKit.zip
zip -r TwitterKit.zip iOS/*
rm -rf iOS
