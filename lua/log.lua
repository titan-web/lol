
ngx.say("get:", "</br>")
local uri_args = ngx.req.get_uri_args()
for k, v in pairs(uri_args) do
    ngx.say(k, ": ", v, "<br />")
end

ngx.say("----", "</br>")

ngx.say("post:")
ngx.req.read_body()
local post_args = ngx.req.get_post_args()
for k, v in pairs(post_args) do
    if type(v) == "table" then
        ngx.say(k, " : ", table.concat(v, ", "), "<br/>")
    else
        ngx.say(k, ": ", v, "<br/>")
    end
end
