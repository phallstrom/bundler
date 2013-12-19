require 'spec_helper'

describe "bundle install with gem sources" do
  describe "when gems include post install messages" do
    it "should display the post-install messages after installing" do
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'rack'
        gem 'thin'
        gem 'rack-obama'
      G

      bundle :install
      expect(out).to include("Post-install message from rack:")
      expect(out).to include("Rack's post install message")
      expect(out).to include("Post-install message from thin:")
      expect(out).to include("Thin's post install message")
      expect(out).to include("Post-install message from rack-obama:")
      expect(out).to include("Rack-obama's post install message")
    end
  end

  describe "when gems do not include post install messages" do
    it "should not display any post-install messages" do
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem "activesupport"
      G

      bundle :install
      expect(out).not_to include("Post-install message")
    end
  end

  describe "when a dependecy includes a post install message" do
    it "should display the post install message" do
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'rack_middleware'
      G

      bundle :install
      expect(out).to include("Post-install message from rack:")
      expect(out).to include("Rack's post install message")
    end
  end
end

describe "bundle install with path sources" do
  describe "when gems include post install messages" do
    it "should display the post-install messages after installing" do
      build_lib "foo", :path => lib_path('foo') do |s|
        s.post_install_message = "Foo's post install message"
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :path => '#{lib_path("foo")}'
      G

      bundle :install
      expect(out).to include("Post-install message from foo:")
      expect(out).to include("Foo's post install message")
    end
  end

  describe "when gems do not include post install messages" do
    it "should not display any post-install messages" do
      build_lib "foo", :path => lib_path('foo') do |s|
        s.post_install_message = nil
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :path => '#{lib_path("foo")}'
      G

      bundle :install
      expect(out).not_to include("Post-install message")
    end
  end
end

describe "bundle install with git sources" do
  describe "when gems include post install messages" do
    it "should display the post-install messages after installing" do
      build_git "foo" do |s|
        s.post_install_message = "Foo's post install message"
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :git => '#{lib_path("foo-1.0")}'
      G

      bundle :install
      expect(out).to include("Post-install message from foo:")
      expect(out).to include("Foo's post install message")
    end

    it "should display the post-install messages if repo is updated" do
      build_git "foo" do |s|
        s.post_install_message = "Foo's post install message"
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :git => '#{lib_path("foo-1.0")}'
      G
      bundle :install

      build_git "foo", "1.1" do |s|
        s.post_install_message = "Foo's 1.1 post install message"
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :git => '#{lib_path("foo-1.1")}'
      G
      bundle :install

      expect(out).to include("Post-install message from foo:")
      expect(out).to include("Foo's 1.1 post install message")
    end

    it "should not display the post-install messages if repo is not updated" do
      build_git "foo" do |s|
        s.post_install_message = "Foo's post install message"
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :git => '#{lib_path("foo-1.0")}'
      G

      bundle :install
      expect(out).to include("Post-install message from foo:")
      expect(out).to include("Foo's post install message")

      bundle :install
      expect(out).not_to include("Post-install message")
    end
  end

  describe "when gems do not include post install messages" do
    it "should not display any post-install messages" do
      build_git "foo" do |s|
        s.post_install_message = nil
      end
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem 'foo', :git => '#{lib_path("foo-1.0")}'
      G

      bundle :install
      expect(out).not_to include("Post-install message")
    end
  end

end
