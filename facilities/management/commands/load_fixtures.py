from django.core.management.base import BaseCommand
from optparse import make_option
from facilities.data_loader import DataLoader
from django.conf import settings

class Command(BaseCommand):
    help = "Load the LGA data from fixtures."

    option_list = BaseCommand.option_list + (
        make_option("-l", "--limit",
                    dest="limit_import",
                    default=False,
                    help="Limit the imported LGAs to the list specified in settings.py",
                    action="store_true"),
        make_option("-d", "--debug",
                    dest="debug",
                    help="print debug stats about the query times.",
                    default=False,
                    action="store_true"),
        make_option("-s", "--data_dir",
                    dest="data_dir",
                    help="Specify where data is pulled from.",
                    default="data",
                    action="store",
                    type="string"),
        )

    def handle(self, *args, **kwargs):
        print kwargs
        data_loader = DataLoader(**kwargs)

        # If no arguments are given to this command run all the import
        # methods.
        if len(args) == 0:
            lga_ids = "all"
            if kwargs['limit_import']:
                lga_ids = settings.LIMITED_LGA_LIST
            # data_loader.setup() is equivalent to the following 5 commands
            data_loader.reset_database()
            data_loader.load_system()
            data_loader.load_data(lga_ids)
            data_loader.load_calculations(lga_ids)
            data_loader.print_stats()

        # If arguments have been given to this command, run those
        # methods in the order they have been specified.
        for arg in args:
            if hasattr(data_loader, arg):
                method = getattr(data_loader, arg)
                method()
            else:
                print "Unknown command:", arg
