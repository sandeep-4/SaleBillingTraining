report 60003 "Update Posted Bill"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Posted Billing Header" = rim;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                PostedBillHdr: Record "Posted Billing Header";
                Cus: Record Customer;
            begin

                if PostedBill = '' then
                    Error('Entere the doc you want to update.');

                PostedBillHdr.Reset();
                PostedBillHdr.SetRange("No.", PostedBill);
                if PostedBillHdr.FindFirst() then begin
                    if CustomerNo <> '' then begin
                        PostedBillHdr."Sell to Customer" := CustomerNo;
                        if Cus.get(CustomerNo) then
                            PostedBillHdr."Customer Name" := Cus.Name;
                    end;
                    PostedBillHdr.Modify();
                end;

                Message('Done');

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Bill)
                {
                    field("Customer No."; CustomerNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer;

                    }
                    field("Posted Bill"; PostedBill)
                    {
                        ApplicationArea = All;
                        TableRelation = "Posted Billing Header";

                    }
                }
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



    var

        CustomerNo: Code[20];

        PostedBill: Code[20];
        myInt: Integer;
}