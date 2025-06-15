#!/bin/sh

echo "👉 Running dart fix..."
dart fix --apply

echo "👉 Running flutter format..."
flutter format --set-exit-if-changed .

if [ $? -ne 0 ]; then
  echo "❌ Format check failed. Please format your code."
  exit 1
fi

echo "👉 Running flutter analyze..."
flutter analyze

if [ $? -ne 0 ]; then
  echo "❌ Analysis failed. Please fix issues."
  exit 1
fi

echo "👉 Running flutter tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Please fix before committing."
  exit 1
fi

echo "✅ All checks passed. Proceeding with commit."

