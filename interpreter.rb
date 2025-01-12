require_relative 'scheme'

class Interpreter < Scheme
    @syntax = {}

    @built_ins = {}

    def self.built_ins
        @built_ins
    end

    def self.built_in(name, &block)
        @built_ins[name] = block
    end

    def self.syntax(name=nil, &block)
        if name
            @syntax[name] = block
        else
            @syntax
        end
    end

    def initialize()
        @syntax = self.class.syntax

        @environment = self.class.built_ins
    end

    def parse(program)
        syntax_tree(tokenize(program))
    end

    def evaluate(expression, environment=@environment)
        if expression.is_a? Numeric
            expression
        elsif expression.is_a? String
            expression
        elsif [ true, false ].include?(expression)
            expression
        elsif expression.is_a? Symbol
            if environment[expression].is_a? Proc
                environment[expression].call()
            else
                environment[expression]
            end
        else
            if expression[0].is_a? Array
                result = nil

                expression.each do |exp|
                    result = evaluate(exp, environment)
                end

                result
            else
                if @syntax.include?(expression[0])
                    block = @syntax[expression[0]]

                    arguments = expression[1..-1]

                    instance_exec(*arguments, &block)
                else
                    arguments = expression[1..-1].map { |arguments|
                        evaluate(arguments, environment)
                    }

                    if environment[expression[0]]
                        environment[expression[0]].call(*arguments)
                    else
                        send(expression[0], *arguments)
                    end
                end
            end
        end
    end
end

require_relative 'interpreter/syntax'
require_relative 'interpreter/built_ins'