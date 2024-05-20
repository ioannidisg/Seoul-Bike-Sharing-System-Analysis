# Seoul-Bike-Sharing-System-Analysis

1. Θεωρείστε τα νοικιασµένα ποδήλατα ανά ώρα (Bikes) σε µια εποχή του έτους (για µια
τιµή του Season). Βρείτε την κατάλληλη γνωστή (παραµετρική) κατανοµή πιθανότητας
που προσαρµόζεται καλύτερα σε αυτά τα δεδοµένα. Επανέλαβε το ίδιο για όλες τις 4
εποχές. 

3. Θεωρείστε νοικιασµένα ποδήλατα ανά ώρα (Bikes) σε µια εποχή του έτους (για µια τιµή
του Season) και για δύο διαφορετικές ώρες της ηµέρας (για δύο διαφορετικές τιµές του
Hour). Ελέγξετε αν διαφέρει το µέσο πλήθος νοικιασµένων ποδηλάτων στις δύο ώρες
της ηµέρας και κατά πόσο. Για αυτό ϑα ϑεωρήσετε νέο δείγµα από τις διαφορές των
αντίστοιχων τιµών ποδηλάτων στις δύο ώρες για την ίδια µέρα (για όλες τις ηµέρες της
εποχής). Με ϐάση αυτό το δείγµα ϑα κάνετε έλεγχο για µέση τιµή µηδέν. Θα κάνετε
τον έλεγχο για όλα τα Ϲευγάρια ωρών (276 Ϲεύγη). Παρουσιάστε τα αποτελέσµατα (µέση
διαφορά ποδηλάτων και απόρριψη ή µη του ελέγχου για µέση διαφορά µηδέν) για όλα τα
Ϲεύγη ωρών, π.χ. χρωµατικός πίνακας (colormap) µεγέθους 24×24 για µέση διαφορά και
αντίστοιχα για τον έλεγχο. Κάντε την παραπάνω διαδικασία για κάθε εποχή και σχολιάστε
αν οι πίνακες αποτελεσµάτων µοιάζουν στις 4 εποχές ή υπάρχουν σηµαντικές διαφορές
για κάποια εποχή.

4. Θεωρείστε νοικιασµένα ποδήλατα ανά ώρα (Bikes) σε δύο εποχές του έτους (για δύο
διαφορετικές τιµές του Season) και για συγκεκριµένη ώρα της ηµέρας (για µια τιµή του
Hour). Θέλουµε να διερευνήσουµε αν διαφέρει το πλήθος νοικιασµένων ποδηλάτων στις
δύο εποχές του έτους και για την ίδια ώρα της ηµέρας. Για αυτό ϑα χρησιµοποιήσετε
διαστήµατα εµπιστοσύνης bootstrap για διαφορά διαµέσων. Θα επαναλάβετε την ίδια διαδικασία
για κάθε µια από τις 24 ώρες τις ηµέρας. Θα παρουσιάσετε τα διαστήµατα εµπιστοσύνης ως προς την
ώρα της ηµέρας.

6. Θεωρείστε νοικιασµένα ποδήλατα ανά ώρα (Bikes) και ϑερµοκρασία (Temperature) για
συγκεκριµένη εποχή του έτους (τιµή του Season) και ώρα της ηµέρας (τιµή του Hour).
Θέλουµε να διερευνήσουµε αν υπάρχει γραµµική συσχέτιση της ενοικίασης ποδηλάτων
µε τη ϑερµοκρασία και για ποιες ώρες της ηµέρας και εποχές εµφανίζονται οι υψηλότερες
συσχετίσεις. Για αυτό για κάθε συνδυασµό ώρας της ηµέρας και εποχής ϑα υπολογίσετε τον
συντελεστή συσχέτισης Pearson και ϑα κάνετε έλεγχο σηµαντικότητας του. Θα
παρουσιάσετε τους συντελεστές συσχέτισης ως προς την ώρα της ηµέρας σε ένα σχήµα
και για κάθε µια από τις 4 εποχές, όπου ϑα πρέπει να ξεχωρίζουν οι στατιστικά σηµαντικές
συσχετίσεις από τις στατιστικά µη-σηµαντικές.
Εντοπίστε τις ισχυρότερες συσχετίσεις και σχολιάστε αν ϕαίνεται να είναι την/τις ίδια/ες
ώρα/ες σε κάθε εποχή.
