tableextension 60007 PostedSalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}