            IWillLiveTo = app.LifeLengthEditField.Value;
            LifeExpectancy =app.LifeExpectancyEditField.Value;
            CurrentAge = app.CurrentAgeEditField.Value;
            StartCapital = app.SavingsEditField.Value;
            StartTaxableSavings = app.TaxableSavingsEditField.Value;
            Income = app.IncomeEditField.Value;
            Expenses = app.ExpensesEditField.Value;
            PriceBaseAmount = app.PriceBaseAmountEditField.Value;
            ROI = 1+app.ROIyearlyEditField.Value/100/12;
            GuarantueedPension = app.GuarantueepensionEditField.Value;
            RetirementAge = app.RetirementAgeEditField.Value;
            EarlyRetirementAge = app.StopWorkAgeEditField.Value;
            StartIncomePension = app.CurrentIncomePensionEditField.Value;
            StartPremiePension = app.CurrentPremiePensionEditField.Value;
            StartServicePension = app.CurrentServicePensionEditField.Value;
            IncomePensionRate = app.IncomePensionRateEditField.Value/100;
            PremiePensionRate = app.PremiePensionRateEditField.Value/100;
            ServicePensionRate = app.ServicePensionRateEditField.Value/100;
            ServicePensionPayoutLength = app.ServicePensionPayoutLengthEditField.Value;
            Savings = StartCapital;
            TaxableSavings = StartTaxableSavings;
            IncomePensionMoney = StartIncomePension;
            PremiePensionMoney = StartPremiePension;
            ServicePensionMoney= StartServicePension;
            IncomeFromROI = StartCapital*ROI-StartCapital;
            PremieFromROI = PremiePensionMoney*(ROI-1);
            ServiceFromROI= ServicePensionMoney*(ROI-1);
            switch app.TaxTableDropDown.Value
                case 'T32'
                    Tax=T32;
                case 'T33'
                    Tax=T33;
                case 'T34'
                    Tax=T34;
                case 'T35'
                    Tax=T35;
            end