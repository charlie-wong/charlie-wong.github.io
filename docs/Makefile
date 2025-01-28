ifeq ('ON', 'OFF')
BuildArgs += --noTimes               # 不同步文件修改时间
BuildArgs += --noBuildLock           # 不创建 .hugo_build.lock
BuildArgs += --printMemoryUsage      # 显示构建期间内存状态
BuildArgs += --panicOnWarning        # panic on first WARNING
BuildArgs += --printI18nWarnings     # WARNING when missing i18n
BuildArgs += --printUnusedTemplates  # WARNING on unused templates
BuildArgs += --printPathWarnings     # WARNING on duplicate target path
endif

OfflineMode = config/offline.toml
BaseTOML = config/charlie.toml,config/hugo.toml

# 本地实时预览
live-preview:
	@hugo server $(BuildArgs) --config "$(BaseTOML)"

# 离线浏览模式
offline-mode:
	@hugo --minify $(BuildArgs) --config "$(BaseTOML),$(OfflineMode)"

# 云端部署网站
release-deploy:
	@hugo --minify $(BuildArgs) --config "$(BaseTOML)"

clean:
	@rm -rf public
	@rm -f hugo_stats.json

distclean: clean
	@rm -rf node_modules
