#!/usr/bin/env python3
"""Verify WebGPU from a qutebrowser QtWebEngine runtime."""

from PyQt6.QtCore import QUrl, QTimer
from PyQt6.QtWebEngineWidgets import QWebEngineView
from PyQt6.QtWidgets import QApplication
import sys


HTML = """
<body>waiting</body>
<script>
window.result = 'missing';
(async () => {
  if (!navigator.gpu) { window.result = 'navigator.gpu missing'; return; }
  const adapter = await navigator.gpu.requestAdapter();
  window.result = adapter ? 'WebGPU adapter OK' : 'WebGPU adapter unavailable';
})();
</script>
"""


app = QApplication(sys.argv)
view = QWebEngineView()
def check(_):
    view.page().runJavaScript("window.result", lambda value: (print(value), app.quit()))

view.loadFinished.connect(check)
view.setHtml(HTML, QUrl("https://webgpu.local/"))
view.show()
app.exec()
