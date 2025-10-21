# frozen_string_literal: true

class BaseUseCase
  # Class method for cleaner invocation
  # Usage: SomeUseCase.call(arg1: value1, arg2: value2)
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs).call(&block)
  end

  # Must be implemented by subclasses
  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end

  protected

  # Success result with data
  def success(data = {})
    Result.new(success: true, data: data, errors: [])
  end

  # Failure result with errors
  def failure(errors)
    errors = [ errors ] unless errors.is_a?(Array)
    Result.new(success: false, data: {}, errors: errors)
  end

  # Result struct for consistent return values
  Result = Struct.new(:success, :data, :errors, keyword_init: true) do
    def success?
      success
    end

    def failure?
      !success
    end

    # Raise an exception if the result is a failure
    def value!
      raise StandardError, errors.join(", ") if failure?
      data
    end
  end
end
