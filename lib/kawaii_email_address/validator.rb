require 'kawaii_email_address/version'
require 'ipaddr'

module KawaiiEmailAddress
  class Validator
    LocalPartChars             = ((?A..?Z).to_a + (?a..?z).to_a + (0..9).to_a).join + %q[!#$%&'*-/=?+-^_`{|}~]
    LocalPartQuotedStringChars = %q[()<>[]:;@,.] << ' '

    PERIOD =        '.'
    BACKSLASH =     '\\'
    DOUBLE_QUOTE =  '"'
    DOMAIN_LITERAL_RE = /\A\[(?<ip_addr>.+)\]\z/

    attr_reader :local_part, :domain_part

    class << self
      attr_accessor :period_restriction_violate_domains
    end

    self.period_restriction_violate_domains = %w[docomo.ne.jp ezweb.ne.jp]

    def initialize(address)
      @domain_part, @local_part = address.reverse.split('@', 2).map(&:reverse)
    end

    def valid?
      both_part_present? && valid_local_part? && valid_domain_part?
    end

    def to_s
      [local_part, domain_part].join('@')
    end

    def both_part_present?
      local_part && domain_part
    end

    def valid_local_part?
      return false if invalid_period_position?

      in_quoted_pair    = false
      in_quoted_string  = false

      is_valid = local_part.chars.each.with_index.all? do |char, i|
        # accept anything if it's got a backslash before it
        if in_quoted_pair
          in_quoted_pair = false
          next true
        end

        case char
        when BACKSLASH # backslash signifies the start of a quoted pair
          # must be in quoted string per http://www.rfc-editor.org/errata_search.php?rfc=3696
          if (i < local_part.length - 1) && in_quoted_string
            in_quoted_pair = true
            next true
          end

        when DOUBLE_QUOTE # double quote delimits quoted strings
          in_quoted_string = !in_quoted_string
          next true

        when PERIOD
          period_restriction_violate_domain? ||
          in_quoted_string ||
          local_part[i + 1] != PERIOD

        else
          LocalPartChars.include?(char) || \
          (in_quoted_string && LocalPartQuotedStringChars.include?(char))

        end
      end

      is_valid && !in_quoted_string
    end

    def valid_domain_part?
      if match = DOMAIN_LITERAL_RE.match(domain_part)
        valid_domain_literal?(match[:ip_addr])
      else
        valid_fqdn_domain_part?
      end
    end

    private

    def valid_domain_literal?(domain)
      begin
        IPAddr.new(domain)
      rescue ArgumentError
        false
      end
    end

    def valid_fqdn_domain_part?
      parts = domain_part.downcase.split('.', -1)

      return false if parts.length <= 1

      return false if parts.any? do |part|
        part.nil? || part.empty? || part !~ /\A[[:alnum:]\-]+\z/ || part.start_with?('-') || part.end_with?('-')
      end

      return false if parts.last.length < 2 || parts.last !~ /[a-z\-]/

      return true
    end

    def period_restriction_violate_domain?
      self.class.period_restriction_violate_domains.include?(domain_part)
    end

    def invalid_period_position?
      return false if period_restriction_violate_domain?

      local_part.start_with?(PERIOD) || local_part.end_with?(PERIOD)
    end
  end
end
