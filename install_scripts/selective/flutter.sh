#!/bin/bash

snap install flutter --classic
flutter doctor

# TODO: add dart install
dart pub global activate melos
