page 60121 "Billing Header Card"
{
    Caption = 'Billing Header Card';
    PageType = Card;
    SourceTable = "Billing Header";

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
                    ShowMandatory = true;

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
                    // trigger OnValidate()
                    // begin
                    //     CurrPage.Update();
                    // end;
                }
                field("Sell to Customer"; Rec."Sell to Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell to Customer field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }

                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Time Filed"; "Time Filed")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Text Time"; "Text Time")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field(TimeDecimal; TimeDecimal)
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }


            }
            group(ListPart)
            {
                part("Billing Line List Part"; "Billing Line List Part")
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
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BillMgt: Codeunit "Bill Management";
                begin
                    if not Confirm('Do you want to post ?', true) then
                        exit;
                    BillMgt.PostBillToPostedBill(Rec."No.");
                    Message('Document has been posted sucessfully.');
                end;
            }

            action("Split Bill")
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BillMgt: Codeunit "Bill Management";
                begin
                    if not Confirm('Do you want to post ?', true) then
                        exit;
                    BillMgt.postItemWiseBill(Rec);
                    Message('Document has been posted sucessfully.');
                end;
            }

            //postItemWiseBill

            action("Total Amounts")
            {
                ApplicationArea = All;
                Image = AmountByPeriod;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BillHeader: Record "Billing Header";
                    SumOfAmt: Decimal;
                begin
                    SumOfAmt := 0;
                    BillHeader.Reset();
                    if BillHeader.FindSet() then
                        repeat
                            BillHeader.CalcFields("Total Amount");
                            SumOfAmt += BillHeader."Total Amount";
                        until BillHeader.Next() = 0;

                    Message(Format(SumOfAmt));
                end;
            }

            action("Total Amounts By CalcSum")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    BillLine: Record "Billing Line";
                    BillHeader: Record "Billing Header";
                    bill: TExt[250];
                begin
                    BillHeader.Reset();
                    BillHeader.SetFilter("Posting Date", '%1..%2', 0D, Today - 3);
                    if BillHeader.FindSet() then
                        repeat
                            if bill <> '' then
                                bill += '|' + BillHeader."No."
                            else
                                bill := BillHeader."No.";
                        until BillHeader.Next() = 0;

                    BillLine.Reset();
                    if bill <> '' then
                        BillLine.SetFilter("Document No.", bill);
                    BillLine.CalcSums("Line Total");
                    Message(Format(BillLine."Line Total"));
                end;



            }

            action("Test")
            {
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    BillLine: Record "Billing Line";
                    BillHeader: Record "Billing Header";
                    bill: TExt;
                    VSBuffer: REcord "CSV Buffer";

                begin
                    //VSBuffer.InsertEntry();
                    if BillHeader.FindSet() then
                        repeat
                            BillLine.SetRange("Document No.", BillHeader."No.");
                            if BillLine.FindSet() then
                                repeat
                                    bill += BillHeader."No." + '|' + BillHeader.Address + '|' + BillLine."Cust No.";
                                until BillLine.Next() = 0;
                            bill += '\n';
                        until BillHeader.Next() = 0;
                end;



            }
        }
    }
}
