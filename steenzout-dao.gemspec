require 'rake'

spec = Gem::Specification.new do |s|

  s.name         = 'steenzout-dao'
  s.version      = '0.1.0'

  s.authors      = ['']
  s.email        = ['']

  s.platform     = Gem::Platform::RUBY

  s.homepage     = 'https://github.com/steenzout/steenzout-dao'

  s.summary      = '.'
  s.description = <<EOF
EOF

  s.has_rdoc     = true
  s.extra_rdoc_files = ["README.textile"]


  s.require_path = 'lib'
  s.files        = FileList["{lib}/**/*"].to_a
  s.test_files   = FileList["{test}/**/*test.rb"].to_a


  s.add_dependency 'json', '>= 1.5.1'
  s.add_dependency 'steenzout-cfg', '>= 1.0.4'
  s.add_dependency 'tokyocabinet', '>= 1.29'

end
