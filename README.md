# README

Rails app to demonstrate the bug being solved by https://github.com/rails/rails/pull/46898

```
docker build -t ror-repro .
podman run -it -p 3000:3000 ror-repro
```

Different errors may surface depending on whether the classic autoloader or zeitwerk is being used, but the root problem is the same.

<details>
<summary>
Error raised when using the classic autoloader
</summary>

```
/usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer.rb:61:in `eager_load!': undefined method `eager_autoload!' for Mail:Module (NoMethodError)
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/application/finisher.rb:134:in `each'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/application/finisher.rb:134:in `block in <module:Finisher>'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:32:in `instance_exec'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:32:in `run'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:61:in `block in run_initializers'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:228:in `block in tsort_each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:350:in `block (2 levels) in each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:431:in `each_strongly_connected_component_from'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:349:in `block in each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `call'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:226:in `tsort_each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:205:in `tsort_each'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:60:in `run_initializers'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/application.rb:391:in `initialize!'
        from /app/config/environment.rb:5:in `<main>'
        from config.ru:3:in `require_relative'
        from config.ru:3:in `block in <main>'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:116:in `eval'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:116:in `new_from_string'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:105:in `load_file'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:66:in `parse_file'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:349:in `build_app_and_options_from_config'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:249:in `app'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:422:in `wrapped_app'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:77:in `log_to_stdout'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:37:in `start'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:144:in `block in perform'
        from <internal:kernel>:90:in `tap'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:135:in `perform'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor/command.rb:27:in `run'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor/invocation.rb:127:in `invoke_command'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor.rb:392:in `dispatch'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/command/base.rb:69:in `perform'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/command.rb:48:in `invoke'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands.rb:18:in `<main>'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /app/bin/rails:5:in `<top (required)>'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/rails.rb:28:in `load'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/rails.rb:28:in `call'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/command.rb:7:in `call'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client.rb:30:in `run'
        from /usr/local/bundle/gems/spring-4.1.0/bin/spring:49:in `<top (required)>'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/binstub.rb:11:in `load'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/binstub.rb:11:in `<top (required)>'
        from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /app/bin/spring:10:in `block in <top (required)>'
        from <internal:kernel>:90:in `tap'
        from /app/bin/spring:7:in `<top (required)>'
        from bin/rails:2:in `load'
        from bin/rails:2:in `<main>'
```

</details>


<details>
<summary>
Error raised when using zeitwerk autoloader
</summary>

```
/usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/delivery_methods.rb:42:in `<module:ClassMethods>': uninitialized constant Mail::TestMailer (NameError)
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/delivery_methods.rb:40:in `<module:DeliveryMethods>'
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/delivery_methods.rb:8:in `<module:ActionMailer>'
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/delivery_methods.rb:5:in `<main>'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/kernel.rb:38:in `require'
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/base.rb:438:in `<class:Base>'
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/base.rb:437:in `<module:ActionMailer>'
        from /usr/local/bundle/gems/actionmailer-6.1.7/lib/action_mailer/base.rb:12:in `<main>'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/kernel.rb:38:in `require'
        from /app/app/mailers/application_mailer.rb:1:in `<main>'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/kernel.rb:30:in `require'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/helpers.rb:135:in `const_get'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/helpers.rb:135:in `cget'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:169:in `block in actual_eager_load_dir'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/helpers.rb:40:in `block in ls'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/helpers.rb:25:in `each'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/helpers.rb:25:in `ls'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:164:in `actual_eager_load_dir'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:17:in `block (2 levels) in eager_load'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:16:in `each'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:16:in `block in eager_load'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:10:in `synchronize'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader/eager_load.rb:10:in `eager_load'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader.rb:296:in `block in eager_load_all'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader.rb:294:in `each'
        from /usr/local/bundle/gems/zeitwerk-2.6.6/lib/zeitwerk/loader.rb:294:in `eager_load_all'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/application/finisher.rb:133:in `block in <module:Finisher>'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:32:in `instance_exec'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:32:in `run'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:61:in `block in run_initializers'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:228:in `block in tsort_each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:350:in `block (2 levels) in each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:431:in `each_strongly_connected_component_from'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:349:in `block in each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `call'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:347:in `each_strongly_connected_component'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:226:in `tsort_each'
        from /usr/local/lib/ruby/3.0.0/tsort.rb:205:in `tsort_each'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/initializable.rb:60:in `run_initializers'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/application.rb:391:in `initialize!'
        from /app/config/environment.rb:5:in `<main>'
        from config.ru:3:in `require_relative'
        from config.ru:3:in `block in <main>'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:116:in `eval'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:116:in `new_from_string'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:105:in `load_file'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/builder.rb:66:in `parse_file'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:349:in `build_app_and_options_from_config'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:249:in `app'
        from /usr/local/bundle/gems/rack-2.2.5/lib/rack/server.rb:422:in `wrapped_app'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:77:in `log_to_stdout'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:37:in `start'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:144:in `block in perform'
        from <internal:kernel>:90:in `tap'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands/server/server_command.rb:135:in `perform'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor/command.rb:27:in `run'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor/invocation.rb:127:in `invoke_command'
        from /usr/local/bundle/gems/thor-1.2.1/lib/thor.rb:392:in `dispatch'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/command/base.rb:69:in `perform'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/command.rb:48:in `invoke'
        from /usr/local/bundle/gems/railties-6.1.7/lib/rails/commands.rb:18:in `<main>'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /usr/local/bundle/gems/bootsnap-1.15.0/lib/bootsnap/load_path_cache/core_ext/kernel_require.rb:32:in `require'
        from /app/bin/rails:5:in `<top (required)>'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/rails.rb:28:in `load'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/rails.rb:28:in `call'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client/command.rb:7:in `call'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/client.rb:30:in `run'
        from /usr/local/bundle/gems/spring-4.1.0/bin/spring:49:in `<top (required)>'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/binstub.rb:11:in `load'
        from /usr/local/bundle/gems/spring-4.1.0/lib/spring/binstub.rb:11:in `<top (required)>'
        from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
        from /app/bin/spring:10:in `block in <top (required)>'
        from <internal:kernel>:90:in `tap'
        from /app/bin/spring:7:in `<top (required)>'
        from bin/rails:2:in `load'
        from bin/rails:2:in `<main>'
```

</details>
