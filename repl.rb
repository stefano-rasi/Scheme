require_relative 'interpreter'

interpreter = Interpreter.new()

loop do
    print '> '

    puts interpreter.evaluate(interpreter.parse(gets))
end