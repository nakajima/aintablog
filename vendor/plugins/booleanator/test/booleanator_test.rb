require File.dirname(__FILE__) + '/../lib/booleanator'
require 'test/unit'

class BooleanatorTest < Test::Unit::TestCase
  
  # Integer Tests
  
  def test_0_should_be_false
    assert ! 0.to_boolean, "0 wasn't false"
  end
  
  def test_1_should_be_true
    assert 1.to_boolean, "1 wasn't true"
  end
  
  def test_2_and_beyond_should_be_true
    2.upto(101) do |i|
      assert i.to_boolean, "#{i} wasn't true"
    end    
  end
  
  # NilClass test
  
  def test_nil_should_be_false
    assert ! nil.to_boolean, "nil wasn't false"
  end
  
  # String tests
  
  def test_zero_should_be_false
    assert ! '0'.to_boolean, %("0" wasn't false)
  end
  
  def test_2_and_beyond_strings_should_be_true
    2.upto(101) do |i|
      assert i.to_s.to_boolean, "#{i} wasn't true"
    end    
  end
  
  def test_true_should_be_true
    assert "true".to_boolean, "'true' wasn't true"
  end
  
  def test_false_should_be_false
    assert ! "false".to_boolean, "'false' wasn't false"
  end
  
  def test_tree_should_be_false
    assert ! "tree".to_boolean, "'tree' wasn't false"
  end
  
  def test_t_should_be_true
    assert "t".to_boolean, "'t' wasn't true"
  end
  
  def test_f_should_be_false
    assert ! "f".to_boolean, "'f' wasn't false"
  end
end
