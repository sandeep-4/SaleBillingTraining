page 60120 "Billing Header List"
{
    ApplicationArea = All;
    Caption = 'Billing Header List';
    PageType = List;
    SourceTable = "Billing Header";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = 60121;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Sell to Customer"; Rec."Sell to Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell to Customer field.';
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All;

                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }

                field("Vendor Name"; VendorName)
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }


            }

        }


    }

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin

        if Vendor.get(Rec."Vendor No.") then
            VendorName := Vendor.Name;

    end;

    var
        VendorName: Text[100];
}
