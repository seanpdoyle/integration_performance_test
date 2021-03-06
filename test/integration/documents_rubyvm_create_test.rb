require 'test_helper'
ActiveSupport::Dependencies.constantize('DocumentsController')

class DocumentsIntegrationTest < ActionDispatch::IntegrationTest
  test "create" do
    post '/documents', params: { document: { title: "New things", content: "Doing them" } }

    document = Document.last
    assert_equal 'New things', document.title
    assert_equal 'Doing them', document.content
  end
end

Minitest.run_one_method(DocumentsIntegrationTest, 'test_create')

# ruby -Ilib:test test/integration/documents_rubyvm_create_test.rb
puts RubyVM.stat
Minitest.run_one_method(DocumentsIntegrationTest, 'test_create')
puts RubyVM.stat
