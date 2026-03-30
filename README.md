# 📸 Widget-to-Image SDK

> **[Self-Contained SDK]**
> *A functional Flutter library utilizing `RepaintBoundary` to capture complex widget trees as high-resolution images or PDF documents.*

A Flutter library for capturing UI widgets as high-resolution images or PDFs. Built for automated reporting and high-fidelity asset generation from mobile and web applications.

- ⚙️ **High Resolution**: Captures widgets at double-pixel density (2x) for print-quality output.
- 📦 **Image & PDF Support**: Exports to PNG, JPG, or PDF formats via RepaintBoundary.
- 🧪 **GetX Support**: Includes a simple controller for state management integration.

### Usage
Use `ModularWTIController.getCaptureController()` to assign a controller to your widgets, then call `captureAllWidgets()` to export the view hierarchy. Includes logic for `generatePDF()` for automated document creation.

**Technical Details:**
Uses the \`RepaintBoundary\` and \`RenderRepaintBoundary\` primitives to convert UI trees into raw bytes. Includes logic for directory management on Android, iOS, and Web.
