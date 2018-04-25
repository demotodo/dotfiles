
http://www.linuxidc.com/Linux/2011-05/35348.htm


Nginx添加模块(非覆盖安装)

[日期：2011-05-01]	来源：Linux社区  作者：Linux	[字体：大 中 小]

 
原已经安装好的nginx，现在需要添加一个未被编译安装的模块:

nginx -V 可以查看原来编译时都带了哪些参数

原来的参数：
--prefix=/app/nginx

添加的参数:
--with-http_stub_status_module --with-http_ssl_module --with-http_realip_module

步骤如下：
1. 使用参数重新配置:
./configure --prefix=/app/nginx -user=nobody -group=nobody --with-http_stub_status_module \
--with-http_ssl_module --with-http_realip_module \
--add-module=../nginx_upstream_hash-0.3.1/ \
--add-module=../gnosek-nginx-upstream-fair-2131c73/
2. 编译:
make
#不要make install，否则就是覆盖安装
3. 替换nginx二进制文件:
cp /app/nginx/sbin/nginx /app/nginx/sbin/nginx.bak
cp ./objs/nginx /app/nginx/sbin/

with-http_realip_module:有些网站使用这样的方式来搭建分布式缓存，若干台Squid放在前面提供缓存服务，内容从后面的 Nginx获取。不过如此一来，Nginx日志里看到的IP就是Squid的IP了，为了能让Nginx透明获取IP，可以使用 NginxHttpRealIpModule。

NginxHttpRealIpModule缺省并没有激活，可以在编译的时候使用--with-http_realip_module选项激活它。

with-http_addition: 这个模块可以在当前的location之前或者之后增加别的location。 
它作为一个输出过滤器执行，包含到其他location中的主请求和子请求不会被完全缓冲，并且仍然
以流的形式传递到客户端，因为最终应答体的长度在传递HTTP头的时候是未知的，HTTP的
chunked编码总是在这里使用。

with-http_gzip_static：nginx静态缓存模块

在搭建squid网页加速的时候，对于大的css 或者js要进行压缩,然后再进行缓存,这样能够提高减小下载量提高页面响应速度。如果你用的是squid 3.0以前的版本并且用的是 ngnix server的话可能会碰到如下问题：不用squid直接打开页面则客户端返回的是压缩的状态，如果启用squid加速会发现下载下来的页面不是压缩状态。这里面主要是没有启动ngnix 的静态缓存模块

with-http_random_index_module :从目录中选择一个随机主页

--with-http_stub_status_module ：这个模块可以取得一些nginx的运行状态

with-http_sub_module ： 这个模块可以能够在nginx的应答中搜索并替换文本。

with-http_dav_module:这个模块增加一些HTTP和webdav扩展动作（PUT, DELETE, MKCOL, COPY和MOVE）

