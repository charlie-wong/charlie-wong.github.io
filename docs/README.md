# Website Technology Information

## Tailwind CSS

- 测试预览 <https://play.tailwindcss.com>
- <https://gohugo.io/functions/css/tailwindcss>
- <https://tailwindcss.com/blog/tailwindcss-v4-alpha>

```bash
# VersionRange1 || VersionRange1          ^ 固定左侧首个非零部分
# 1.2.3 - 2.3.4 等同于 >=1.2.3 <=2.3.4    ~ 补丁级, 占位符 * 或 x 或 X

npm i -g tailwindcss@next @tailwindcss/cli@next

npm i; npm install # 本地安装 package.json 开发环境依赖
npm i    PkgName   # 本地安装(位于 ./node_modules 目录)

npm i -S PkgName;  npm install --save     PkgName  # 生产环境 dependencies
npm i -D PkgName;  npm install --save-dev PkgName  # 开发环境 devDependencies
npm i -g PkgName;  npm install --global   PkgName  # 全局安装(命令行使用)
```

## 关于 Hugo 模板

- <https://gohugo.io/templates/introduction>
- <https://www.topgoer.com/常用标准库/template.html>
- 内置变量/函数 <https://gohugo.io/quick-reference>

- 目录结构布局
  ```text
  contentDir    默认值 content       原始的 markup 文件
  publishDir    默认值 public        生成的静态 HTML 网站

  archetypeDir  默认值 archetypes    命令 `hugo new` 模板文件
  layoutDir     默认值 layouts       HTML 布局模板文件
  themesDir     默认值 themes        主题搜索目录

  assetDir      默认值 assets        最小化 JS/CSS 文件
  staticDir     默认值 static        静态资源(复制拷贝)
  dataDir       默认值 data          自定义数据
  i18nDir       默认值 i18n          本地化翻译
  ```

- 极简模板语法
  ```go-html-template
  {{/* 注释 */}}    模板注释               {{ .VAR }}         当前上下文
  {{  ⋯  }}        调用变量和函数         {{ $.VAR }}        全局上下文
  {{- ⋯ -}}        删除渲染后的空白字符   {{ $VAR := true }} 变量初始化
  ```

- 渲染核心概念
  * <https://gohugo.io/methods/page/kind>
  * <https://gohugo.io/methods/page/currentsection>
  * <https://gohugo.io/templates/lookup-order>
  * <https://gohugo.io/templates/output-formats>
  * <https://discourse.gohugo.io/t/template-lookup-a-guide/24710>
  * <https://deploy-preview-1805--gohugoio.netlify.app/templates/lookup-order>
  * 源码 `output/layouts/layout.go`
  ```txt
  index.md  叶绑定 .Page.Kind=page
  _index.md 枝绑定 .Page.Kind={home,section,taxonomy,term}

  => .Page.Kind, .Page.Type, .Page.Layout
  content/_index.md            -> .Kind = home      (默认值).Type = page
  content/*.md                 -> .Kind = page      (默认值).Type = page
  content/X1/*.md              -> .Kind = page      (默认值).Type = X1
  content/X2/_index.md         -> .Kind = section   (默认值).Type = X2
  content/X3/X4/_index.md      -> .Kind = section   (默认值).Type = X3
  content/分类/术语/_index.md  -> .Kind = term      (默认值).Type = 分类
  content/分类/_index.md       -> .Kind = taxonomy  (默认值).Type = 分类

  layoutDir/[Folders]/FileName.[LangCode.][Outputformat.]Suffix
  .Kind 有效值 home, page, section, taxonomy(分类), term(术语)
  => md 文件 FrontMatter 设置 type(.Page.Type) 或 layout(.Page.Layout)
  home
    content/_index.md           => baseURL/
      Folders                   .Type   >  "/"  > _default
      FileName                  .Layout > index > home > list
  page
    content/about.md            =>  baseURL/about/
    content/about/index.md      =>  baseURL/about/
    content/X0/one.md           =>  baseURL/X0/one/
    content/X1/two/index.md     =>  baseURL/X1/two/
      Folders                   .Type > _default
      FileName                  .Layout > single
  section
    content/X3/_index.md        =>  baseURL/X3/
      Folders                   .Type > section > _default
      FileName                  .Layout > section > list

  配置文件 => [taxonomies] 单数 = "复数"
  taxonomy
    content/复数/_index.md      =>  baseURL/复数/
      Folders                   .Type > 单数 > taxonomy > _default
      FileName                  .Layout > 单数.terms > terms > taxonomy > list
  term
    content/复数/术语/_index.md  =>  baseURL/复数/术语/
      Folders                   .Type > term > taxonomy > 单数 > _default
      FileName                  .Layout > term > 单数 > taxonomy > list
  ```
