-- Changes the ID type of the equipment table, and updates FKs

select id, uuid_generate_v4() as new_id into temp table tmp_equipment_id_map from equipment;
create or replace function tmp__get_equipment_id_map(int8)
returns uuid language sql as $$
    select new_id from tmp_equipment_id_map where id = $1
$$;

alter table equipment_notes drop constraint public_equipment_notes_equipment_id_fkey;

alter table equipment alter column id drop identity if exists;
alter table equipment alter column id set data type uuid using tmp__get_equipment_id_map(id);
alter table equipment alter column id set default uuid_generate_v4();

alter table equipment_notes alter column equipment_id set data type uuid using tmp__get_equipment_id_map(equipment_id);

alter table equipment_notes add constraint public_equipment_notes_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;
alter table equipment_notes validate constraint public_equipment_notes_equipment_id_fkey;

drop function tmp__get_equipment_id_map;
drop table tmp_equipment_id_map;