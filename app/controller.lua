---
--- Created by titan.
--- DateTime: 2018/1/29 14:16
---
--加载Lua模块库


--1、获取请求参数中的商品ID
local skuId = ngx.var.skuId;
ngx.say(skuId)
