title: hexo
categories: [Tips]
date: 2018-05-23 09:57:35
---

# hexo
> [官方文档](https://hexo.io/zh-cn/docs/index.html)

### 安装前提
- node.js
- git

`$ npm install -g hexo-cli`

具体文件作用见官方文档

## Algolia
```
node:9751) [DEP0061] DeprecationWarning: fs.SyncWriteStream is deprecated.
FATAL Something's wrong. Maybe you can find the solution here: http://hexo.io/docs/troubleshooting.html
AlgoliaSearchError: Please provide an API key. Usage: algoliasearch(applicationID, apiKey, opts)
    at AlgoliaSearchNodeJS.AlgoliaSearchCore (/Users/hechangtong/Projects/blog/node_modules/algoliasearch/src/AlgoliaSearchCore.js:55:11)
    at AlgoliaSearchNodeJS.AlgoliaSearch (/Users/hechangtong/Projects/blog/node_modules/algoliasearch/src/AlgoliaSearch.js:11:21)
    at AlgoliaSearchNodeJS.AlgoliaSearchServer (/Users/hechangtong/Projects/blog/node_modules/algoliasearch/src/server/builds/AlgoliaSearchServer.js:17:17)
    at new AlgoliaSearchNodeJS (/Users/hechangtong/Projects/blog/node_modules/algoliasearch/src/server/builds/node.js:79:23)
    at algoliasearch (/Users/hechangtong/Projects/blog/node_modules/algoliasearch/src/server/builds/node.js:68:10)
    at Hexo.module.exports (/Users/hechangtong/Projects/blog/node_modules/hexo-algolia/lib/command.js:22:16)
    at Hexo.tryCatcher (/Users/hechangtong/Projects/blog/node_modules/bluebird/js/release/util.js:16:23)
    at Hexo.ret (eval at makeNodePromisifiedEval (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/promisify.js:184:12), <anonymous>:13:39)
    at /Users/hechangtong/Projects/blog/node_modules/hexo/lib/hexo/index.js:195:9
    at Promise._execute (/Users/hechangtong/Projects/blog/node_modules/bluebird/js/release/debuggability.js:300:9)
    at Promise._resolveFromExecutor (/Users/hechangtong/Projects/blog/node_modules/bluebird/js/release/promise.js:483:18)
    at new Promise (/Users/hechangtong/Projects/blog/node_modules/bluebird/js/release/promise.js:79:10)
    at Hexo.call (/Users/hechangtong/Projects/blog/node_modules/hexo/lib/hexo/index.js:191:10)
    at /usr/local/lib/node_modules/hexo-cli/lib/hexo.js:66:17
    at tryCatcher (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/util.js:16:23)
    at Promise._settlePromiseFromHandler (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/promise.js:512:31)
    at Promise._settlePromise (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/promise.js:569:18)
    at Promise._settlePromise0 (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/promise.js:614:10)
    at Promise._settlePromises (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/promise.js:693:18)
    at Async._drainQueue (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/async.js:133:16)
    at Async._drainQueues (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/async.js:143:10)
    at Immediate.Async.drainQueues (/usr/local/lib/node_modules/hexo-cli/node_modules/bluebird/js/release/async.js:17:14)
➜  blog export HEXO_ALGOLIA_INDEXING_KEY=xxxxxxxxxxxxx
➜  blog hexo algolia
(node:9765) [DEP0061] DeprecationWarning: fs.SyncWriteStream is deprecated.
INFO  [Algolia] Testing HEXO_ALGOLIA_INDEXING_KEY permissions.
INFO  Start processing
INFO  [Algolia] Identified 153 posts to index.
INFO  [Algolia] Start indexing...
```
## Theme
主题我选择github上Star数最高的(hexo-theme-next)[https://github.com/iissnan/hexo-theme-next/blob/master/README.cn.md]

```
    modified:   _config.yml
    modified:   layout/_custom/sidebar.swig
    modified:   source/css/_custom/custom.styl
Untracked files:
  (use "git add <file>..." to include in what will be committed)
    source/images/avatar.jpg
```


