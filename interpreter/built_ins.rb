class Interpreter
    built_in(:-) do |*arguments|
        arguments.inject(:-)
    end

    built_in(:+) do |*arguments|
        arguments.inject(:+)
    end

    built_in(:eq?) do |a, b|
        if a == b
            true
        else
            false
        end
    end

    built_in(:list) do |*elements|
        elements
    end
end