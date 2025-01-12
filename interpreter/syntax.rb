class Interpreter
    syntax(:and) do |*conditions|
        if conditions.all?
            true
        else
            false
        end
    end

    syntax(:define) do |identifier, expression|
        if identifier.is_a? Array
            @environment[identifier[0]] = lambda { |*parameters|
                environment = @environment

                identifier[1..-1].each_with_index do |argument, i|
                    environment[argument] = parameters[i]
                end

                evaluate(expression, environment)
            }
        else
            @environment[identifier] = lambda {
                evaluate(expression)
            }
        end
    end

    syntax(:if) do |condition, expression_1, expression_2|
        if evaluate(condition)
            evaluate(expression_1)
        elsif expression_2
            evaluate(expression_2)
        end
    end

    syntax(:or) do |*conditions|
        if conditions.any?
            true
        else
            false
        end
    end

    syntax(:quote) do |expression|
        lambda do
            evaluate(expression)
        end
    end
end