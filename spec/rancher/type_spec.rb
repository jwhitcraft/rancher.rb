require 'helper'

describe Rancher::Type do
  let(:type) { Rancher::Type }
  let(:url) { 'http://test.dev/' }
  context '#list_href' do

    context 'with existing url' do
      it 'will append query string to url' do
        actual = type.list_href('/test/', {
                                          :filters => {
                                            :k => 42
                                          }
                                        })
        expect(actual).to eq '/test/?k=42'
      end

      it 'will keep existin query string' do
        actual = type.list_href('/test/?jon=test', {
                                          :filters => {
                                            :k => 42
                                          }
                                        })
        expect(actual).to eq '/test/?jon=test&k=42'
      end
    end

    context 'with filters' do
      it 'will not contain any filters' do
        actual = type.list_href(url, {})

        expect(actual).to_not include('?')
      end

      it 'will contain k=42' do
        actual = type.list_href(url, {
                                    :filters => {
                                      :k => 42
                                    }
                                  })
        expect(actual).to include('k=42')
      end

      it 'will use modifiers' do
        actual = type.list_href(url, {
                                    :filters => {
                                      :k => [
                                        {:modifier => 'ne', :value => 43},
                                        {:modifier => 'gt', :value => 44}
                                      ]
                                    }
                                  })
        expect(actual).to include('k_ne=43&k_gt=44')
      end

      it 'will use modifiers and standard values' do
        actual = type.list_href(url, {
                                    :filters => {
                                      :k => [
                                        {:modifier => 'ne', :value => 43},
                                        {:modifier => 'gt', :value => 44},
                                        45
                                      ],
                                      :j => 46
                                    }
                                  })
        expect(actual).to include('k_ne=43&k_gt=44&k=45&j=46')
      end
    end

    context 'with sort' do
      it 'query string contains sort' do
        actual = type.list_href(url, {
                                    :sort => {
                                      :name => 'test'
                                    }
                                  })

        expect(actual).to include('sort=test')
      end

      it 'query string contains sort but not order asc' do
        actual = type.list_href(url, {
                                    :sort => {
                                      :name => 'test',
                                      :order => 'asc'
                                    }
                                  })

        expect(actual).to include('sort=test')
        expect(actual).to_not include('&order=asc')
      end

      it 'query string contains sort and order=desc' do
        actual = type.list_href(url, {
                                    :sort => {
                                      :name => 'test',
                                      :order => 'desc'
                                    }
                                  })

        expect(actual).to include('sort=test&order=desc')
      end
    end

    context 'pagination' do
      it 'url will contain limit' do
        actual = type.list_href(url, {
                                    :pagination => {
                                      :limit => 100
                                    }
                                  })
        expect(actual).to include('limit=100')
      end
      it 'url will contain marker' do
        actual = type.list_href(url, {
                                    :pagination => {
                                      :limit => 100,
                                      :marker => 2
                                    }
                                  })
        expect(actual).to include('limit=100&marker=2')
      end
    end

    context 'include' do
      it 'will include everything' do
        actual = type.list_href(url, {
                                    :include => %w(one two three)
                                  })
        expect(actual).to include('include=one&include=two&include=three')
      end
    end
  end
end
