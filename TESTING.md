## Preparations
- `matrix-each bundle install`

## Running Tests
- `matrix-each rspec`

## Focusing on a test
See https://stackoverflow.com/a/5072879/2490686
```
# spec/my_spec.rb
describe SomeContext do
  it "won't run this" do
    raise "never reached"
  end

  it "will run this", :focus => true do
    1.should == 1
  end
end

$ rspec --tag focus spec/my_spec.rb
```
