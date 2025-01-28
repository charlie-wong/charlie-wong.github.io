+++
draft = true
date  = '{{ time.Now | time.AsTime }}'
# description = 'html-meta-description'
# keywords = [ 'html', 'meta', 'keywords' ]
title = '{{ strings.Replace .File.ContentBaseName "-" " " | strings.Title }}'
[params]
  [params.author]
    name  = 'html-meta-author'
    email = ''
+++
