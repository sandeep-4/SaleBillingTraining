table 60113 "Billing Line"
{
    Caption = 'Billing Line';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            // TableRelation = "Billing Header"."No.";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                Item: Record Item;
                BillLine: Record "Billing Line";
                BillLine1: Record "Billing Line";
            begin
                if Item.Get("Item No.") then begin
                    "Unit Price" := Item."Bill Amount";
                    Description := Item.Description;
                end;

                // BillLine.Reset();
                // BillLine.SetRange("Document No.", Rec."Document No.");

                // if BillLine.FindSet() then
                //     repeat
                //         if BillLine."Item No." = "Item No." then
                //             Error('The item already exists. %1', "Item No.");
                //     until BillLine.Next() = 0;
                //Dipendra
                BillLine.Reset();
                BillLine.SetRange("Document No.", Rec."Document No.");
                BillLine.SetRange("Item No.", Rec."Item No.");
                if BillLine.FindFirst() then
                    Error('Duplicate item is found');





                //Dipendra

                // BillLine.Reset();
                // BillLine.SetRange("Document No.", Rec."Document No.");
                // if BillLine.FindSet() then
                //     repeat
                //         if BillLine."Item No." = "Item No." then begin
                //             BillLine.Quantity += 1;
                //             BillLine.Modify();
                //         end;
                //     until BillLine.Next() = 0;

                // BillLine1.Reset();
                // BillLine1.SetRange("Document No.", Rec."Document No.");
                // BillLine1.SetRange("Item No.", "Item No.");
                // if BillLine1.FindLast() then
                //     BillLine1.Delete();



            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                TotalPrice: Decimal;
                BillingHeader: Record "Billing Header";
            begin

                "Line Total" := Quantity * "Unit Price";
                // BillingHeader."Total Amount" := "Line Total";

            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item."Unit Price" where("No." = field("Item No.")));

        }
        field(7; "Line Total"; Decimal)
        {
            Caption = 'Line Total';
            DataClassification = ToBeClassified;

        }

        field(8; "Cust No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        BillHeader: Record "Billing Header";
    begin
        if BillHeader.Get("Document No.") then
            Rec."Cust No." := BillHeader."Sell to Customer";
    end;


    var
}
