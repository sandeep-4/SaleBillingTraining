report 60001 "Bill Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\Report\RDLC\BillSummary.rdl';

    dataset
    {
        dataitem(DataItemName; "Posted Billing Header")
        {
            column(No_; "No.")
            {

            }

            column(Sell_to_Customer; "Sell to Customer")
            {

            }

            column(Type; Type)
            {

            }

            column(showCustomer; showCustomer) { }

            column(User_ID; "User ID") { }

            column(Customer_Name; "Customer Name") { }

            column(Tax; Tax) { }

            column(Image; CompInfo.Picture) { }

            column(CompName; compInfo.Name) { }

            column(CompPhone; CompInfo."Phone No.") { }

            column(CompAdd; CompInfo.Address)
            {

            }

            column(Address; Address)
            {

            }
            dataitem("Posted Billing Line"; "Posted Billing Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }

                column(Unit_Price; "Unit Price") { }

                column(Amount_After_Tax; "Amount After Tax") { }

            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                PurchAndPay.Get();
                Tax := PurchAndPay."Bill Tax %";

                CompInfo.Get;
                CompInfo.CalcFields(Picture);


            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Type = Type::Customer then
                    showCustomer := true;
            end;


        }



    }



    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;

        PurchAndPay: Record "Purchases & Payables Setup";

        Tax: Decimal;
        showCustomer: Boolean;

        CompInfo: Record "Company Information";
}