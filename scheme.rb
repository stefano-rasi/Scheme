class Scheme
    def atom(token)
        if /^"/.match?(token)
            token[1..-2]
        elsif /\.d+/.match?(token)
            token.to_f
        elsif /\d+/.match?(token)
            token.to_i
        else
            token.to_sym
        end
    end

    def tokenize(program)
        tokens = []

        last_token = ''

        program.each_char do |char|
            if %w{( )}.include?(char)
                if not last_token.empty?
                    tokens << last_token

                    last_token = ''
                end

                tokens << char
            else
                if /\s/.match?(char)
                    if not last_token.empty?
                        tokens << last_token

                        last_token = ''
                    end
                else
                    last_token << char
                end
            end
        end

        tokens
    end

    def syntax_tree(tokens)
        list = []

        while not tokens.empty?
            token = tokens.shift()

            if token == '('
                list << syntax_tree(tokens)
            elsif token == ')'
                break
            else
                list << atom(token)
            end
        end

        list
    end
end