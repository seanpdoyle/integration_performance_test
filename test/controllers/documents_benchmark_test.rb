require 'test_helper'
require 'benchmark/ips'

class RailsDomTestingDocumentsIntegrationTest < ActionDispatch::IntegrationTest
  assert_with :rails_dom_testing

  test "index" do
    document = Document.create!(title: "title", content: "content")

    get '/documents'
    assert_equal 200, response.status

    assert_select "h1", text: document.title
    assert_select "p", text: document.content
  end

  test "create" do
    post '/documents', params: { document: { title: "New things", content: "Doing them" } }
    follow_redirect!

    document = Document.last

    assert_select "h1", text: document.title
    assert_select "p", text: document.content
  end
end

class CapybaraMinitestDocumentsIntegrationTest < ActionDispatch::IntegrationTest
  assert_with :capybara

  test "index" do
    document = Document.create!(title: "title", content: "content")

    get '/documents'
    assert_equal 200, response.status

    assert_selector "h1", text: document.title
    assert_selector "p", text: document.content
  end

  test "create" do
    post '/documents', params: { document: { title: "New things", content: "Doing them" } }
    follow_redirect!

    document = Document.last

    assert_selector "h1", text: document.title
    assert_selector "p", text: document.content
  end
end

Benchmark.ips(5) do |bm|
  bm.report 'INDEX: rails-dom-testing' do
    Minitest.run_one_method(RailsDomTestingDocumentsIntegrationTest, 'test_index')
  end

  bm.report 'INDEX: capybara/minitest' do
    Minitest.run_one_method(CapybaraMinitestDocumentsIntegrationTest, 'test_index')
  end

  bm.compare!
end

Benchmark.ips(5) do |bm|
  bm.report 'CREATE: rails-dom-testing' do
    Minitest.run_one_method(RailsDomTestingDocumentsIntegrationTest, 'test_create')
  end

  bm.report 'CREATE: capybara/minitest' do
    Minitest.run_one_method(CapybaraMinitestDocumentsIntegrationTest, 'test_create')
  end

  bm.compare!
end
