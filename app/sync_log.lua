
--- 设置返回的html的header
ngx.header.content_type = 'text/html; charset=utf-8';
local req = ngx.req.get_uri_args()
--- 获取a参数，并判断是否有值，若没有返回701的status，表示请求不成功
local a  = req["a"]
if a == nil then
    ngx.exit(701)
end
--- 获取time,ip,ua,b,c参数
local req_headers = ngx.req.get_headers()
local b = req["b"]
local c = req["c"]
local curTime = ngx.localtime()
local ip = ngx.var.remote_addr
local ua = req_headers["User-Agent"]
--- 若请求中未带b或c参数，置其为空字符串
if nil == b then
    b = ""
end
if nil == c then
    c = ""
end
--- 拼接一行日志中的内容
local msg = cur_time .. "\02" .. ip .. "\x02" .. ua .. "\x02" .. a .. "\02" .. b .. "\02" .. c .. "\n"
--- 获取当前时间周期，用于判断是否需要进行文件句柄的滚动
local cur_hour_level = string.sub(ngx.localtime(), 1, 13)
--- 当大于时，表示到了需要滚动日志文件句柄的时候
if cur_hour_level > example_test_log_hour_level then
    --- 在共享字典中，用add命令实现类似于锁的用途。
    --- 只有当共享字典中原来没有要add的key时，才能操作成功，否则失败。
    --- 这样的话，有多个请求时，只能有一个请求add成功，而其他请求失败，休眠0.01秒后重试。
    --- 唯一add成功的那个请求，则关闭老文件句柄，并滚动新文件句柄，并更新表示文件句柄的时间周期的那个全局变量。
    local shared_dict = ngx.shared.example_test_dict
    local rotate_key = "log_rotate"
    while true do
        if cur_hour_level == example_test_log_hour_level then
            break
        else
            -- the exptime, is to prevent dead-locking
            local ok, err = shared_dict:add(rotate_key, 1, 10)
            if not ok then
                ngx.sleep(0.01)
            else
                if cur_hour_level > example_test_log_hour_level then
                    example_test_log_closeFile()
                    example_test_log_openFile()
                    if example_test_log_fo == nil then
                        ngx.log(ngx.ERR, "example_test_log_openFile error")
                        ngx.exit(911)
                    end
                    example_test_log_hour_level_update(cur_hour_level)
                end
                shared_dict:delete(rotate_key)
                break
            end
        end
    end
end
--- 落地日志内容
example_test_log_fo:write(msg)
example_test_log_fo:flush()
--- 正常退出，返回请求，表示成功
ngx.exit(ngx.HTTP_OK)

