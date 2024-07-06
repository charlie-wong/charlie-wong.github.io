cmake:
	@cmake -S . -B build

clean:
	@rm -rf build
	@rm  -f hello-*

# 编译缓存目录 ~/.cache/go-build/
# $ go clean -cache       删除编译缓存
# $ go clean -fuzzcache   删除fuzz缓存
#   go run hello.go
hello-go:
	@go build hello.go
	@strip    hello
	@mv hello hello-go

hello-nim:
	nim compile -d:release hello.nim
	@strip    hello
	@mv hello hello-nim

hello-rust:
	@rustc    hello.rs
	@strip    hello
	@mv hello hello-rust
