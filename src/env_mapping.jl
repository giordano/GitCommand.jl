function _env_mapping(; adjust_PATH::Bool = true,
                                     adjust_LIBPATH::Bool = true)
    if Sys.iswindows()
        git_path, env_mapping = Git_jll.git(; adjust_PATH = adjust_PATH,
                                              adjust_LIBPATH = adjust_LIBPATH) do git_path
            env_mapping = Dict{String,String}()
            if haskey(ENV, "PATH")
                env_mapping["PATH"] = ENV["PATH"]
            end
            if haskey(ENV, Git_jll.LIBPATH_env)
                env_mapping[Git_jll.LIBPATH_env] = ENV[Git_jll.LIBPATH_env]
            end
            return git_path, env_mapping
        end
        return git_path, env_mapping
    end
    git_path, env_mapping = Git_jll.git(; adjust_PATH = adjust_PATH,
                                          adjust_LIBPATH = adjust_LIBPATH) do git_path
        git_core = joinpath(dirname(dirname(git_path)), "libexec", "git-core")
        libcurlpath = dirname(Git_jll.LibCURL_jll.libcurl_path)
        originallibpath = get(ENV, Git_jll.LIBPATH_env, "")
        ssl_cert = joinpath(dirname(Sys.BINDIR), "share", "julia", "cert.pem")

        sep = _separator()

        env_mapping = Dict{String,String}()
        env_mapping["GIT_EXEC_PATH"] = git_core
        env_mapping["GIT_SSL_CAINFO"] = ssl_cert
        env_mapping[Git_jll.LIBPATH_env] = "$(libcurlpath)$(sep)$(originallibpath)"
        if haskey(ENV, "PATH")
            env_mapping["PATH"] = ENV["PATH"]
        end
        return git_path, env_mapping
    end
    return git_path, env_mapping
end
