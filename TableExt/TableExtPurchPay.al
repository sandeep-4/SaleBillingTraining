tableextension 60001 PurchPayeXt extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

        field(60002; "Bill Tax %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}