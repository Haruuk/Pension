
%%
%Assumes marrige (worse case)
%Assumes no increase in salary
% https://www.pensionsmyndigheten.se/statistik/publikationer/orange-rapport-2021/4-sa-fungerar-den-allmanna-pensionen.html
%Assumes no fees on savings or Premie Pension
%Assumes no one born in your year dies. 0 Inheritence from other's deaths.

% IWillLiveTo = 100;   %years
% LifeExpectancy = 83; %years
% CurrentAge = 26;     %years
%
% StartCapital = 400000;      %SEK
% StartTaxableSavings = 20000;%SEK
%
% Income = 39000;         %Monthly
% Expenses = 15000;       %Monthly
%
% PriceBaseAmount = 47600;
%
% ROI = 1+0.02/12;%Monthly, 2% growth per year with the growth taxed
%
%
% GuarantueedPension = 10631; %Monthly
% RetirementAge = 67;
% EarlyRetirementAge = 55;
%
%
% % Update by: https://mina-sidor.minpension.se/oversikt
% StartIncomePension = 61021;
% StartPremiePension = 3529;
% StartServicePension = 10578;
%
% IncomePensionRate = 0.16;
% PremiePensionRate = 0.025;
% ServicePensionRate= 0.045;
%
% ServicePensionPayoutLength = 15; %Years
%
%
% Savings = StartCapital;
% TaxableSavings = StartTaxableSavings;
% IncomePensionMoney = StartIncomePension;
% PremiePensionMoney = StartPremiePension;
% ServicePensionMoney= StartServicePension;
%
% IncomeFromROI = StartCapital*ROI-StartCapital;
% PremieFromROI = PremiePensionMoney*(ROI-1);
% ServiceFromROI= ServicePensionMoney*(ROI-1);
%
%
% %https://skatteverket.se/privat/etjansterochblanketter/blanketterbroschyrer/broschyrer/info/403.4.39f16f103821c58f680007749.html
% %https://www.skatteverket.se/privat/skatter/arbeteochinkomst/askattsedelochskattetabeller/salaserdutabellen.4.319dc1451507f2f99e875f.html
% %Taxes based on table 34
% T34;
% Tax = Table34;

Time = linspace(CurrentAge,IWillLiveTo,(IWillLiveTo-CurrentAge)*12);

for i = 1:length(Time)-1
    %%
    if Time(i) < EarlyRetirementAge % While working

        IncomeTaxBracket  = find(Tax(:,1)<=Income(i),1,'last');
        
        if Income(i)-Tax(IncomeTaxBracket,2) < Expenses
            ExpensesLeft = Expenses-(Income(i)-Tax(IncomeTaxBracket,2));
        else
            ExpensesLeft = 0;
        end

        Savings(i+1) = Savings(i)*ROI + (Income(i)-Tax(IncomeTaxBracket,2))-Expenses+ExpensesLeft;

        if TaxableSavings(i) <= 0 %Slightly worse case as we tax an enitre month expenses even if only half was taxable.
            %We have no taxable savings so we dont pay any tax
            Savings(i+1) = Savings(i+1)-ExpensesLeft;
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1);
        else
            %We have taxable savings so we pay with that
            Savings(i+1) = Savings(i+1) - ExpensesLeft*(1+0.3);
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1) - ExpensesLeft*(1+0.3);
        end
%%



        % Savings(i+1) = Savings(i)*ROI + (Income(i)-Tax(IncomeTaxBracket,2)) - Expenses;
        % %The return on investment is taxed by 30%, we need to keep
        % %track of this money
        % TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1);


        IncomePensionMoney(i+1) = IncomePensionMoney(i) + Income(i)*IncomePensionRate;
        PremiePensionMoney(i+1) = PremiePensionMoney(i)*ROI + Income(i)*PremiePensionRate;
        ServicePensionMoney(i+1)= ServicePensionMoney(i)*ROI + Income(i)*ServicePensionRate;

        Income(i+1) = Income(i);

        %%
    elseif Time(i) < RetirementAge %Stopped working but before pension
        %When money is extracted from the savings pool it is taxed
        %based on the growth of that money. This applies tax to all
        %money extracted from savings giving a worse case. We assume
        %all withdrawals made are taxed according to the growth as
        %long as there is still taxable money. (We only withdraw
        %winnings untill we are back at savings)

        if TaxableSavings(i) <= 0 %Slightly worse case as we tax an enitre month expenses even if only half was taxable.
            %We hav no taxable savings so we dont pay any tax
            Savings(i+1) = Savings(i)*ROI - Expenses;
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1);
        else
            %We have taxable savings so we pay with that
            Savings(i+1) = Savings(i)*ROI - Expenses*(1+0.3);
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1) - Expenses*(1+0.3);
        end

        IncomePensionMoney(i+1) = IncomePensionMoney(i);
        PremiePensionMoney(i+1) = PremiePensionMoney(i)*ROI;
        ServicePensionMoney(i+1)= ServicePensionMoney(i)*ROI;

        Income(i+1) = 0;

        %%
    else %Stopped working and recieving pension
        %%
        %https://www.pensionsmyndigheten.se/statistik/publikationer/orange-rapport-2021/4-sa-fungerar-den-allmanna-pensionen.html
        %income pension is < 1.14 price base amounts, it is entierly guarantueed
        %pension
        if (IncomePensionMoney(i)/12/(LifeExpectancy-RetirementAge)) < 1.14*PriceBaseAmount/12
            IncomePensionPayout(i+1) = GuarantueedPension;

            %income pension is > 2.83 price base amounts, it is entierly income pension
        elseif (IncomePensionMoney(i)/12/(LifeExpectancy-RetirementAge)) > 2.83*PriceBaseAmount/12

            IncomePensionPayout(i+1) = (IncomePensionMoney(i)/12/(LifeExpectancy-RetirementAge));

            %income pension is in between, it is a mix
        else
            IncomePensionPayout(i+1) = IncomePensionMoney(i)/12/(LifeExpectancy-RetirementAge)...
                + ((2.181-1.26)*PriceBaseAmount/12 ...
                -0.48*(IncomePensionMoney(i)/12/(LifeExpectancy-RetirementAge)-1.26*PriceBaseAmount/12));
        end




        %%
        % PremiePensionPayout
        if i/12+26 > RetirementAge && i/12+26 < LifeExpectancy
            PremiePensionPayout(i+1) = PremiePensionMoney(i)/12/(LifeExpectancy-(i/12+CurrentAge));
        else
            PremiePensionPayout(i+1) = 0;
        end

        %%
        %ServicePensionPayout
        if i/12+26 > RetirementAge && i/12+26 < RetirementAge+ServicePensionPayoutLength
            ServicePensionPayout(i+1) = ServicePensionMoney(i)/12/(ServicePensionPayoutLength-(i/12+CurrentAge-RetirementAge));
        else
            ServicePensionPayout(i+1) = 0;
        end
        %%
        TotalPensionPayout(i+1) =   IncomePensionPayout(i+1)+...
                                    PremiePensionPayout(i+1)+...
                                    ServicePensionPayout(i+1);

        IncomePensionMoney(i+1) = IncomePensionMoney(i);
        PremiePensionMoney(i+1) = PremiePensionMoney(i)*ROI-PremiePensionPayout(i+1);
        ServicePensionMoney(i+1)= ServicePensionMoney(i)*ROI-ServicePensionPayout(i+1);

        IncomeTaxBracket  = find(Tax(:,1)<=TotalPensionPayout(i+1),1,'last');

        %%
        %If the pension is not enough to cover expenses we dip into
        %savings, starting with taxable savings
        if (TotalPensionPayout(i+1)-Tax(IncomeTaxBracket,3)) < Expenses
            ExpensesLeft = Expenses-(TotalPensionPayout(i+1)-Tax(IncomeTaxBracket,3));
        else
            ExpensesLeft = 0;
        end

        Savings(i+1) =Savings(i)*ROI + (TotalPensionPayout(i+1)-Tax(IncomeTaxBracket,3))-Expenses+ExpensesLeft;

        if TaxableSavings(i) <= 0 %Slightly worse case as we tax an enitre month expenses even if only half was taxable.
            %We have no taxable savings so we dont pay any tax
            Savings(i+1) = Savings(i+1)-ExpensesLeft;
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1);
        else
            %We have taxable savings so we pay with that
            Savings(i+1) = Savings(i+1) - ExpensesLeft*(1+0.3);
            TaxableSavings(i+1) = TaxableSavings(i) + Savings(i)*(ROI-1) - ExpensesLeft*(1+0.3);
        end
        Income(i+1)=0;

    end

    IncomeFromROI(i+1)=Savings(i)*ROI-Savings(i);
    PremieFromROI(i+1)=PremiePensionMoney(i)*ROI-PremiePensionMoney(i);
    ServiceFromROI(i+1)=ServicePensionMoney(i)*ROI-ServicePensionMoney(i);


end



