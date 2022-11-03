pageextension 60078 GeneralJournalExt extends "General Journal"
{
    layout
    {
        addafter(Amount)
        {
            field(Training; REc.Training)
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("DeleteDiensionCode")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Visible = true;

                trigger OnAction()
                var

                    DefDimesion: Record "Default Dimension";
                    salesPeople: Record "Salesperson/Purchaser";

                begin
                    if DefDimesion.Get(13, 'KH', 'SALESPERSON') then
                        DefDimesion.Delete();
                    Message('Deleted');

                    DefDimesion.Reset();
                    DefDimesion.SetRange("No.", 'KH');
                    if DefDimesion.FindFirst() then
                        DefDimesion.Delete();


                end;

            }
        }
    }

    var
        myInt: Integer;
}