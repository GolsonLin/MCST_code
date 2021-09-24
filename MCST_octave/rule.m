    function [rule_decide, answer_order]=rule(response,cardAttributes)
        if response==cardAttributes(1) % colorrule
            ruleNum=1;
            rule_decide=1;
        elseif response==cardAttributes(2)% shaperule
            ruleNum=2;
            rule_decide=1;
        elseif response==cardAttributes(3) % numrule
            ruleNum=3;
            rule_decide=1;
        else
            ruleNum=0;
            rule_decide=0;
        end
        switch ruleNum
            case 0
                answer_order=0;
            case 1
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[1 2 3];
                else
                    answer_order=[1 3 2];
                end
            case 2
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[2 1 3];
                else
                    answer_order=[2 3 1];
                end
            case 3
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[3 2 1];
                else
                    answer_order=[3 1 2];
                end
        end
    endfunction