require "email_format_validator/version"

LocalPartSpecialChars      = /[\!\#\$\%\&\'\*\-\/\=\?\+\-\^\_\`\{\|\}\~]/
LocalPartQuotedStringChars = /[\(\)\<\>\[\]\:\;\@\,\.\ ]/

module EmailFormatValidator
  class Address
    attr_reader :local_part, :domain_part

    def initialize(address)
      @@domain_part, @local_part = address.reverse.split('@', 2).map(&:reverse)
    end

    def valid?
      valid_local_part?
    end

    def to_s
      [@local_part, @domain_part].join('@')
    end

    def valid_local_part?
      in_quoted_pair    = false
      in_quoted_string  = false

      (0..local_part.length - 1).each do |i|
        ord = local_part[i].ord

        # accept anything if it's got a backslash before it
        if in_quoted_pair
          in_quoted_pair = false
          next
        end

        # backslash signifies the start of a quoted pair
        if ord == 92 and i < local_part.length - 1
          return false if not in_quoted_string # must be in quoted string per http://www.rfc-editor.org/errata_search.php?rfc=3696
          in_quoted_pair = true
          next
        end

        # double quote delimits quoted strings
        if ord == 34
          in_quoted_string = !in_quoted_string
          next
        end

        next if local_part[i, 1] =~ /[a-z0-9]/i
        next if local_part[i, 1] =~ LocalPartSpecialChars

        if in_quoted_string
          next if local_part[i, 1] =~ LocalPartQuotedStringChars

          if in_quoted_pair
            next if local_part[i, 1] == '"'
          end
        end

        # period must be followed by something
        if ord == 46
          return false if i == 0 or i == local_part.length - 1 # can't be first or last char

          next if in_quoted_string || local_part[i + 1].ord != 46 # can't be followed by a period
        end

        return false
      end

      return false if in_quoted_string # unbalanced quotes
      return true
    end
  end
end
