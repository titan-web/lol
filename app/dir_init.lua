---
--- Created by titan.
--- DateTime: 2018/1/29 14:14
---

local cjson = require "cjson";
local configCache = ngx.shared.config_cache;

local resourcesFile =  io.open("/Users/titan/repository/lol/config/resources.properties", "r");
local resourcesStr = resourcesFile:read("*a");
resourcesFile:close();


local resourcesJson = cjson.decode(resourcesStr);
ngx.log(ngx.ERR, "========begin config=========");
for k,v in pairs(resourcesJson) do
    ngx.log(ngx.ERR, "key:" .. k .. ", value:" .. v);
end
ngx.log(ngx.ERR, "========end config=========");

--- 方便更改日志落地的基本目录
local EXAMPLE_TEST_LOG_DIR_BASE = "/path/to/log/dir"
--- 日志文件中名称的前面部分，方便识别
local EXAMPLE_TEST_FILENAME_PRE = "example"
--- 日志所属的当前周期的全局变量，小时级
example_test_log_hour_level = string.sub(ngx.localtime(), 1, 13)
--- 更新日志所属的当前周期的全局变量的函数
--- 之所以用函数更新，因为全局变量在跨文件时是无法更新的，下面的函数也是同理
function example_test_log_hour_level_update(hour_level)
    example_test_log_hour_level = hour_level
end
--- 日志落地的文件句柄，全局变量
example_test_log_fo = nil
--- 更新日志落地文件句柄的全局变量的函数
function example_test_log_openFile()
    local curT = ngx.time()     --unix timestamp, in seconds
    local dir_path = EXAMPLE_TEST_LOG_DIR_BASE .. "/" .. os.date("%Y%m/%d/%H", curT)
    local exec_code = os.execute("mkdir -m 755 -p " .. dir_path)
    if 0 ~= exec_code then
        ngx.log(ngx.ERR, "can't mkdir -m 755 -p " .. dir_path)
        return nil
    end
    local file_path = dir_path .. "/" .. EXAMPLE_TEST_FILENAME_PRE .. os.date("_%Y%m%d%H.log", curT)

    local err_msg, err_code
    example_test_log_fo, err_msg, err_code = io.open(file_path, "a")
    if nil == example_test_log_fo then
        ngx.log(ngx.ERR, "can't open file: " .. file_path .. ", " .. err_msg .. ", " ..  err_code)
        return nil
    else
        os.execute("chmod 644 " .. file_path)
        return example_test_log_fo
    end
end
--- 关闭日志句柄的函数
function example_test_log_closeFile()
    if example_test_log_fo ~= nil then
        example_test_log_fo:close()
    end
end
--- 在init时调用一次，初始化文件句柄
example_test_log_openFile()
