#!/usr/bin/env ruby

def get_words(doc)
  doc.split(/\W/).select { |word| (word.length > 2) && (word.length < 20) }.map(&:downcase).uniq
end

def sample_train(cl)
  cl.train("Nobody owns the water.", "good")
  cl.train("the quick rabbit jumps fences", "good")
  cl.train("buy pharmaceuticals now", "bad")
  cl.train("make quicl money at the online casino", "bad")
  cl.train("the quick brown fox jumps", "good")
end

class Classifier
  def initialize(get_features, filename = "")
    @feature_counts = {}
    @category_counts = {}
    @get_features = get_features
  end

  def inc_feature(feature, category)
    @feature_counts[feature] ||= {}
    @feature_counts[feature][category] ||= 0
    @feature_counts[feature][category] += 1
  end

  def inc_category(category)
    @category_counts[category] ||= 0
    @category_counts[category] += 1
  end

  def feature_count(feature, category)
    if @feature_counts[feature] && @feature_counts[feature][category]
      @feature_counts[feature][category].to_f
    else
      0.0
    end
  end

  def category_count(category)
    @category_counts[category] ? @category_counts[category].to_f : 0.0
  end

  def total_count
    @category_counts.values.inject(&:+)
  end

  def train(item, category)
    features = self.send(@get_features, item)
    features.map! { |feature| inc_feature(feature, category) }
    inc_category(category)
  end
end
