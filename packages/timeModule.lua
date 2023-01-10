-- date and time module
local module = {}

function module.Now()
  -- get current date and time
  local now = os.date("*t")
  return now
end

function module.Date()
    -- get current date
    local now = module.Now()
    return string.format("%02d/%02d/%04d", now.month, now.day, now.year)
  end

function module.Time()
    -- get current time
    local now = module.Now()
    local period = "AM"
    if now.hour >= 12 then
      period = "PM"
    end
    return string.format("%02d:%02d %s", now.hour % 12, now.min, period)
end

return module
