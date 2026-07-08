-- Hammerspoon 初始配置
-- 快捷键前置：Ctrl + Alt

-- 窗口快照到屏幕左半
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local frame = screen:frame()
  win:setFrame(hs.geometry.rect(frame.x, frame.y, frame.w / 2, frame.h))
end)

-- 窗口快照到屏幕右半
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local frame = screen:frame()
  win:setFrame(hs.geometry.rect(frame.x + frame.w / 2, frame.y, frame.w / 2, frame.h))
end)

-- 窗口全屏
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "F", function()
  hs.window.focusedWindow():toggleFullScreen()
end)
