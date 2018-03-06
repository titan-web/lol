local headers=ngx.req.get_headers()
local client_ip = headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"
local host_name = ngx.var.server_addr
local cdn_src_ip = headers["HTTP_CDN_SRC_IP"] or "-"
local cur_time = ngx.localtime()
local method = ngx.var.request_method
local full_url = '-'
local server_protocol = ngx.var.server_protocol
local status_code = ngx.var.status or '-'
local content_length = ngx.var.body_bytes_sent or '-'
local http_host = ngx.var.http_host or '-'
local agent = ngx.var.http_user_agent or '-'
local run_time = '-'
local request_length = ngx.var.request_length

if ngx.var.request_method then
    full_url = ngx.var.request_uri
end

run_time = ngx.now() - ngx.req.start_time()

ngx.var.analysis = string.format("%s    %s    %s    [%s]    %s    %s    %s    %s    %s    %s    %s    %sms    %s", client_ip, host_name, cdn_src_ip, cur_time, method, full_url, server_protocol, status_code, content_length, http_host, agent, run_time, request_length)
