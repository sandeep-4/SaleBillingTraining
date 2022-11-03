page 60124 "Posted Billing Header Card"
{
    Caption = 'Posted Billing Header Card';
    PageType = Card;
    SourceTable = "Posted Billing Header";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
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
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }
            }
            group(ListPart)
            {
                part("Posted Billing Line List Part"; "Posted Billing Line List Part")
                {
                    SubPageLink = "Document No." = field("No.");
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }
        }


    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedBillHdr: Record "Posted Billing Header";
                begin
                    PostedBillHdr.Reset();
                    PostedBillHdr.SetRange("No.", Rec."No.");
                    if PostedBillHdr.FindFirst() then
                        Report.Run(Report::"Bill Invoice", true, true, PostedBillHdr);
                end;
            }
        }
    }
}
