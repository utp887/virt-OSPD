#!/bin/bash

# Garbage collection
find . -name "*.retry" -exec rm -f {} \;

# Krynn
if [ -f ../krynn-ansible/files/ssh/krynn_rsa ]; then
	ssh-add ../krynn-ansible/files/ssh/krynn_rsa
fi

# Provide hints:
echo -e "(II) Here are some suggestions for some specific systems:"
echo -e "----------------------------------------------"
echo -e " - ravenvale\t\t: 32G config or 'ravenvale' config"
echo -e " - daltigoth\t\t: 64G config or 'daltigoth' config"
echo -e " - palanthas\t\t: 160G config or 'palanthas' config"
echo -e " - thorbardin\t\t: 192G config or 'thorbardin' config"
echo -e "----------------------------------------------"

# Select OSP version..
PS3="(II) Please select an OSP version: "
select option in 8 9 10 11 12 13
do
	case ${option} in
		8|9|10|11|12|13)
			OSP=${option}
			break
			;;
		*)
			echo "(**) Wrong option select, try again..."
			;;
	esac
done

# Select RAM
PS3="(II) Please select memory config for your hypervisor: "
select option in 32G 64G 128G 160G 192G 256G daltigoth palanthas thorbardin ravenvale
do
	case ${option} in
		32G|64G|128G|160G|192G|256G|daltigoth|palanthas|thorbardin|ravenvale)
			RAM=${option}
			break
			;;
		*)
			echo "(**) Wrong option select, try again..."
			;;
	esac
done

#
echo "(II) RH-OSP v${OSP} on ${RAM} RAM selected, proceeding..."
PLAYB="playbooks/virt-env-ospd/ospd_${OSP}_${RAM}.yml"
if [ -f ${PLAYB} ]; then
	set -x
	ansible-playbook -i inventories/virt-env-ospd/hosts ${PLAYB} $@
else
	echo "(**) No ansible playbook found at: ${PLAYB}"
fi
